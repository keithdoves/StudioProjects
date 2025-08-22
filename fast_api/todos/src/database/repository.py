
from typing import List

from fastapi import Depends
from sqlalchemy import select, delete
from sqlalchemy.orm import Session

from database.connection import get_db
from database.orm import ToDo, User


class ToDoRepository:
    def __init__(self, session: Session = Depends(get_db)):
        self.session = session

    def get_todos(self) -> List[ToDo]:
        return list(self.session.scalars(select(ToDo)))

    def get_todo_by_id(self, todo_id: int) -> ToDo | None:
        return self.session.scalar(select(ToDo).where(ToDo.id == todo_id))

    def create_todo(self, todo: ToDo) -> ToDo:
        self.session.add(instance=todo)
        self.session.commit()  # db save
        self.session.refresh(instance=todo)  # db read -> todo_id
        return todo

    # 아래 create_todo와 update_todo 로직이 똑같음
    # SQLAlchemy에서 새로 만든 인스턴트인데, PK가 없으면 INSERT함
    # update할 때, 먼저 DB에서 PK 기준으로 레코드를 갖고옴.
    # 이렇게 객체를 로드하면 해당 todo_객체는 Persistent 상태가 되고
    # identity_map에 저장됨.
    # todo_ 객체의 속성을 바꾸면 이 객체는 dirty 상태가 됨
    # 커밋 시점에 Persistent+Dirty 인 객체에 대해 UPDATE를 실햄함.
    def update_todo(self, todo: ToDo) -> ToDo:
        self.session.add(instance=todo)
        self.session.commit()  # db save
        self.session.refresh(instance=todo)
        return todo

    def delete_todo(self, todo_id: int) -> None:
        self.session.execute(delete(ToDo).where(ToDo.id == todo_id))
        self.session.commit()


class UserRepository:
    def __init__(self, session: Session = Depends(get_db)):
        self.session = session

    def save_user(self, user: User) -> User:
        self.session.add(instance=user)
        self.session.commit()
        self.session.refresh(instance=user)
        return user

    def get_user_by_username(self, username: str) -> User | None:

        return self.session.scalar(
            select(User).where(User.username == username)
        )

