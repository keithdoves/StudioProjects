from fastapi import HTTPException
from fastapi import APIRouter, Depends

from cache import valkey_client
from database.repository import UserRepository
from schema.request import SignUpRequest, LogInRequest, CreateOTPRequest
from schema.response import UserSchema, JWTResponse
from security import get_access_token
from service.user import UserService
from database.orm import User

router = APIRouter(prefix="/users")


@router.post("/sign-up", status_code=201)
def user_sign_up_handler(
        # 1. request body(username, password)
        request: SignUpRequest,
        user_service: UserService = Depends(),
        user_repo: UserRepository = Depends(),
):
    # 2. password -> hashing(암호화) -> hashed_password
    hashed_password: str = user_service.hash_password(
        plain_password=request.password,
    )

    # (유저가 동일한 비밀번호로 로그인하면 해싱된 값이 같다는 걸 검증)
    # 3. User(username, hashed_password) orm객체 생성
    # orm 객체는 매핑되는 DB 테이블을 알고 있고(__tablename__)
    # 컬럼 매핑 정보와 session 상태 정보를 알고 있기 때문에
    # pydantic 객체는 db 통신에 적절하지 않음.
    # pydantic 객체는 직렬화 등을 위한 데이터 구조 명세서임.

    user: User = User.create(username=request.username,
                             hashed_password=hashed_password,
                             )

    # 4. user -> db save
    user: User = user_repo.save_user(user=user)  # id=int

    # 5. return user(id, username)
    return UserSchema.from_orm(user)


@router.post("/log-in", status_code=201)
def user_log_in_handler(
        # 1. request body(username, password)
        request: LogInRequest,
        user_repo: UserRepository = Depends(),
        user_service: UserService = Depends(),
):
    # 2. db read user
    user: User = user_repo.get_user_by_username(username=request.username)

    # 3. user.password, request.password -> bcrypt.checkpw
    if not user:
        raise HTTPException(status_code=404, detail="User Not Found")

    verified = user_service.verify_password(plain_password=request.password,
                                            hashed_password=user.password,
                                            )

    if not verified:
        raise HTTPException(status_code=401, detail="Not Authorized")

    # 4. create jwt
    access_token : str = user_service.create_jwt(username=user.username)

    # 5. return jwt
    return JWTResponse(access_token=access_token)

# 회원가입(username, password) / 로그인
# 이메일 알림 : 회원가입 -> 이마엘 인증(OTP) -> 유저 이메일 저장 -> 이메일 알림

# POST /users/email/otp -> (key: email, value: 1234, exp: 3min)
# POST /users/email/otp/verify -> request(email, otp) -> user(email)

@router.post("/email/otp")
def create_otp_handler(
        request : CreateOTPRequest,
        _ : str = Depends(get_access_token), # _로 처리해서 헤더에 토큰 유무만 검증
        user_service : UserService =Depends(),

):

    # 3. otp create(random 4 digit)
    otp : int = user_service.create_otp()

    # 4. save on valkey otp(email, 1234, exp=3min)
    valkey_client.set(request.email, otp)
    valkey_client.expire(request.email, 3 * 60)

    # 5. send otp to email
    return {"opt": otp}

@router.post("/email/otp/verify")
def verify_otp_handler():
    return
