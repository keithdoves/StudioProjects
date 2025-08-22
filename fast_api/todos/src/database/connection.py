from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# db종류+드라이버://사용자이름:비밀번호@DB주소:포트/접속할DB이름
DATABASE_URL = "mysql+pymysql://root:todos@127.0.0.1:3306/todos"

# echo=True : SQL쿼리를 콘솔에 출력
engine = create_engine(DATABASE_URL)

# 호출할 때마다 새로운 세션 생성 / 세션은 DB 작업을 위한 일종의 공간
# autocommit=False : session.commit()할 때만 DB에 최종 커밋함.
# autoflush=False : 세션에 변경사항이 생길 때마다 DB에 flush하는 것을 직접 session.flush()하거나 커밋시 반영됨.
# flush는 일종의 임시저장. DB에 변경사항을 보내지만 트랜잭션이 끝나지 않아 변경사항을 조회할 수 없음.
# flush는 문제가 생기면 롤백할 수 있음. commit은 flush를 포함.
SessionFactory = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    session = SessionFactory()
    try:
        yield session
    finally:
        session.close()