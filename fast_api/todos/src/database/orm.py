from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy import Boolean, Column, Integer, String
from sqlalchemy.sql.schema import ForeignKey

from schema.request import CreateToDoRequest

# ORM 만들기
# 실제 Table의 모든 컬럼을 정의할 필요 없음

Base = declarative_base()

class ToDo(Base):
    __tablename__ = "todo"

    id = Column(Integer, primary_key=True, index=True)
    contents = Column(String(256),nullable=False)
    is_done = Column(Boolean, nullable=False)
    user_id = Column(Integer, ForeignKey("user.id"))


    # 파이썬 내장 메서드를 오버라이드함.
    def __repr__(self):
        return f"ToDO(id={self.id}, contents={self.contents}, is_done={self.is_done})"


    # 이 데코레이터는 ToDo.create()으로 Static하게 함수를 쓸 수 있게 함.
    @classmethod
    def create(cls, request: CreateToDoRequest) -> "ToDo":
        # 이 메서드는 request를 담은 pydantic 객체를
        # DB에 저장하기 위해 orm으로 리턴하는 역할
        # cls는 자기 자신을 의미하여 cls는 ToDo 임
        return cls(
            # id는 DB에서 자동으로 생성하기 때문에 값지정 X
            contents=request.contents,
            is_done=request.is_done,
        )

    # 인스턴스 값을 변경하는 경우 클래스 메서드로 구현하는 것이
    # 관리하기 편함
    # "ToDO_"로 문자열로 명시하는 것은 전방 참조를 위한 관례
    # 함수가 정의될 때 ToDo_ 클래스가 선언되지 않으면 런타임 에러 발생
    # 또한 순환참조 회피 가능.
    def done(self) -> "ToDo":
        self.is_done = True
        return self

    def undone(self) -> "ToDo":
        self.is_done = False
        return self

    def delete(self):
        self.is_done = False


class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(256), nullable=False)
    password = Column(String(256), nullable=False)
    # todos 컬럼이 생성되는 것이 아니라
    # User를 조회하는 시점에 "ToDo"를 조인하여 함께 조회해옴
    todos = relationship("ToDo", lazy="joined")

    @classmethod
    def create(cls, username: str, hashed_password: str)-> "User":
        return cls(
            username = username,
            password = hashed_password,
        )