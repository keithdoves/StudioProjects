from typing import List

from pydantic import BaseModel

## ORM이 있는데도 schema를 만드는 이유
## 역할과 책임의 분리 & 보안
## ORM 모델을 그대로 사용하면 API가 매우 취약해지고 유연성이 떨어짐
## ORM 모델 : DB와 대화하기 위한 객체. Table의 구조, 컬럼 타입, 관계 등을 정의
## Schema : API를 통해 클라이언트와 데이터를 주고받기 위한 객체.
         ## API의 입력 및 출력 데이터 형식을 정의하고 유효성 검사를 책임짐.
## ORM (데이터 CRUD) <-> Schema (데이터 주고 받기)
##

class ToDoSchema(BaseModel):
    id: int
    contents: str
    is_done: bool

    # sqlalchemy orm 객체를 넘겨주면
    # pydantic이 알아서 위 스키마에 맞춰줌.
    class Config:
        orm_mode = True

# 최종 결과물의 설명서 / 이 클래스를 리턴하면 FastAPI
class ToDoListSchema(BaseModel):
    todos: List[ToDoSchema]

class UserSchema(BaseModel):
    id: int
    username: str

    class Config:
        orm_mode = True

class JWTResponse(BaseModel):
    access_token: str