from typing import List

from fastapi import Depends, HTTPException, Body, APIRouter
from database.orm import ToDo, User
from database.repository import ToDoRepository, UserRepository
from schema.request import CreateToDoRequest
from schema.response import ToDoSchema, ToDoListSchema
from security import get_access_token
from service.user import UserService


router = APIRouter(prefix="/todos")
# router를 정의하여 main에 연결시켜줌.
# 즉 main에 모든 api를 정의하지 않고 나눠 관리할 수 있게 라우팅을 연결
# prefix로 반복되는 경로 정의


@router.get("/{todo_id}", status_code=200)
def get_todo_handler(
    todo_id: int,
    todo_repo: ToDoRepository = Depends(),
) -> ToDoSchema:
    todo: ToDo | None = todo_repo.get_todo_by_id(todo_id=todo_id)
    if todo:
        return ToDoSchema.from_orm(todo)
    raise HTTPException(status_code=404, detail="ToDo Not Found")



@router.get("", status_code=200)
def get_todos_handler( #handler 실행 전 모든 Depends를 실행시킴.
                      access_token: str = Depends(get_access_token),
                      order: str | None = None,
                      user_service: UserService = Depends(),
                      user_repo: UserRepository = Depends(),
                      ) ->ToDoListSchema:

    username: str = user_service.decode_jwt(access_token=access_token)
    user: User | None = user_repo.get_user_by_username(username=username)
    if not user:
        raise HTTPException(status_code=404, detail="User Not Found")

    todos: List[ToDo]  = user.todos

    if todos and order =="DESC":
        return ToDoListSchema(
            todos=[ToDoSchema.from_orm(todo) for todo in todos[::-1]]
        )
    return ToDoListSchema(
        todos=[ToDoSchema.from_orm(todo) for todo in todos]
    )
    # todo_id 없으면 {} 리턴
    # ret = todo_data.get(todo_id, {})
    # return ret



@router.post("", status_code=201)
def create_todo_handler(request: CreateToDoRequest,
                        todo_repo: ToDoRepository = Depends(),
                        ) -> ToDoSchema:
    # pydantic BaseModel에 내장된 dict() 메서드로 타입 변환
    # FE의 RequestBody를 자동으로 Pydantic_BaseModel인 CreateToDoRequest로 자동 맵핑함.
    # Create의 경우 : pydantic 객체 -> orm으로 변환 -> orm으로 db에 저장
    # 다른 경우 : db에서 orm으로 가져옴 -> pydantic으로 변환 -> pydantic(schema)로 response
    todo: ToDo = ToDo.create(request=request) # 이 시점에 id=None / orm으로 변환
    todo: ToDo = todo_repo.create_todo(todo=todo) # DB에 실제 저장 & id 가진 ToDo 객체 리턴

    return ToDoSchema.from_orm(todo)


@router.patch("/{todo_id}", status_code=200)
def update_todo_handler(
        todo_id: int,
        is_done: bool = Body(..., embed=True),
        todo_repo: ToDoRepository = Depends(ToDoRepository),
        # is_done: Annotated[bool, Body(embed=True)], : 현대적인 문법
):
# class 전체가 아니라 하나의 프로퍼티만 업데이트 하는 경우
# Body를 이용하여 request body로부터 값을 가져 와야 함을 명시
# ... : is_done이 필수라는 것을 뜻함.
# embed=True : request body에서 is_done을 키로 하는 Json 객체를 기대함.
# embed=False : request body에서 Json객체가 아닌 순수한 bool 값을 기대함.

    todo: ToDo | None = todo_repo.get_todo_by_id(todo_id=todo_id) # 객체 로드
    if todo:
        todo.done() if is_done else todo.undone()                        # Dirty 표시
        todo: ToDo = todo_repo.update_todo(todo= todo)            # UPDATE
        return ToDoSchema.from_orm(todo)                                 # 업데이트 결과 리턴
    raise HTTPException(status_code=404, detail="Todo Not Found")


@router.delete("/{todo_id}", status_code=204)
def delete_todo_handler(todo_id : int,
                        todo_repo: ToDoRepository = Depends(),
                        ):
    todo: ToDo | None = todo_repo.get_todo_by_id(todo_id=todo_id, )

    if not todo:
        raise HTTPException(status_code=404, detail="ToDo Not Found")

    todo_repo.delete_todo(todo_id=todo_id)
