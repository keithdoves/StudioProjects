import bcrypt
from datetime import datetime, timedelta
from jose import jwt
import random

class UserService:
    encoding: str = "UTF-8"
    secret_key: str = "7f9acc6a48d7cff46afa5dcf53607b01124006d4c032df8cb07bb4cfc478ec61"
    jwt_algorithm: str = "HS256"

    def hash_password(self, plain_password: str) -> str:
        hashed_password: bytes = bcrypt.hashpw(
            plain_password.encode(self.encoding),
            salt=bcrypt.gensalt()
        )

        return hashed_password.decode(self.encoding)

    def verify_password(
            self, plain_password: str, hashed_password: str
    ) -> bool:
        # try/except
        return bcrypt.checkpw(
            plain_password.encode(self.encoding),
            hashed_password.encode(self.encoding)
        )

    def create_jwt(self, username: dict) -> str:
        return jwt.encode({"sub": username,
                           "exp": datetime.now() + timedelta(days=1)  # 만료시간 설정
                           },
                          self.secret_key, algorithm=self.jwt_algorithm, )

    def decode_jwt(self, access_token: str) -> str:
        payload: dict = jwt.decode(
            access_token,
            self.secret_key,
            algorithms=[self.jwt_algorithm],
        )

        return payload["sub"]

    @staticmethod # 인스턴스에 접근할 필요 없기 때문에 static으로
    def create_otp() -> int :
        return random.randint(1000, 9999)