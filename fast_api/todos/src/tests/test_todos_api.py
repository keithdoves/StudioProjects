from database.orm import ToDo, User
from database.repository import ToDoRepository
from service.user import UserService


# 테스트 클라이언트 생성하여 테스트 실시함.
# 이후 fixture로 대체됨(client)
# client = TestClient(app)

#
# def test_get_todos_using_mocker(mocker, client):
#     # main.py에 있는 get_todos 함수를 모킹함(DB 접근함수)
#     mocker.patch("api.todo.get_todos", return_value=[
#         # 이 값은 DB와 같을 필요 없음.
#         ToDo(id=1, contents="Mark", is_done=True),
#         ToDo(id=2, contents="Letti", is_done=True),
#         ToDo(id=3, contents="LLOYD", is_done=False)
#     ])
#     response = client.get("/todos")
#     assert response.status_code == 200
#     assert response.json() == {
#         "todos": [
#             # 리턴값(DB)이 아래와 일치해야 테스트 통과됨.
#             {"id": 1, "contents": "Mark", "is_done": True},
#             {"id": 2, "contents": "Letti", "is_done": True},
#             {"id": 3, "contents": "LLOYD", "is_done": False},
#         ]
#     }


def test_get_todos(client, mocker):
    access_token : str = UserService().create_jwt(username="test")
    headers = {"Authorization": f"Bearer {access_token}"}

    user = User(id=1, username="test", password="hashed")
    user.todos = [
        ToDo(id=1, contents="Mark", is_done=True),
        ToDo(id=2, contents="Letti", is_done=True),
        ToDo(id=3, contents="LLOYD", is_done=False),
    ]

    mocker.patch.object(ToDoRepository, "get_todos", return_value=user)


    response = client.get("/todos", headers=headers)
    assert response.status_code == 200
    assert response.json() == {
        "todos": [
            # 리턴값(DB)이 아래와 일치해야 테스트 통과됨.
            {"id": 1, "contents": "Mark", "is_done": True},
            {"id": 2, "contents": "Letti", "is_done": True},
            {"id": 3, "contents": "LLOYD", "is_done": False},
        ]
    }
    # DESC 검증
    response = client.get("/todos?order=DESC")
    assert response.status_code == 200
    assert response.json() == {
        "todos": [
            # 리턴값(DB)이 아래와 일치해야 테스트 통과됨.
            {"id": 3, "contents": "LLOYD", "is_done": False},
            {"id": 2, "contents": "Letti", "is_done": True},
            {"id": 1, "contents": "Mark", "is_done": True},
        ]
    }


def test_get_todo(client, mocker):
    # When 200
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=ToDo(id=1, contents="Mark", is_done=True)
    )
    response = client.get("/todos/1")
    assert response.status_code == 200
    assert response.json() == {"id": 1, "contents": "Mark", "is_done": True}

    # When 404
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=None
    )
    response = client.get("/todos/1")
    assert response.status_code == 404
    assert response.json() == {"detail": "ToDo Not Found"}


def test_create_todo(client, mocker):

    # spy: 특정객체를 추적해서 객체의 리턴이나 연산 등을 저장함.
    create_spy = mocker.spy(ToDo, "create")
    mocker.patch.object(ToDoRepository,
        "create_todo",
        return_value=ToDo(id=1, contents="Mark", is_done=True)
    )

    # create는 requestbody가 필요해서 body를 만들어줌
    body = {"contents": "test",
            "is_done": False,
            }

    #json이란 key에 body를 전달하면 requestbody로 처리함.
    response = client.post("/todos", json=body)
    assert create_spy.spy_return.id is None # 아직 DB에 저장되지 않았기 때문에
    assert create_spy.spy_return.contents == "test"
    assert create_spy.spy_return.is_done is False

    assert response.status_code == 201
    assert response.json() == {"id": 1, "contents": "Mark", "is_done": True}

def test_update_todo(client, mocker):
    # When 200
    # 1. get_todo_by_id() → is_done=True인 ToDo를 리턴
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=ToDo(id=1, contents="Mark", is_done=True)
    )
    # 2. ToDo.undone() 메서드를 mock 객체로 대체 (호출 여부 추적 가능)
    undone = mocker.patch.object(ToDo, "undone")

    # 3. update_todo() → 실제 동작 대신, is_done=False 상태의 ToDo를 리턴
    mocker.patch.object(ToDoRepository,
        "update_todo",
        return_value=ToDo(id=1, contents="Mark", is_done=False)
    )

    # 4. 클라이언트가 PATCH 요청을 보냄 (is_done=False로 변경하겠다는 의도)
    # 테스트 대상 코드의 트리거
    # 테스트 코드 구조에서는 항상 마지막에 배치하는 것이 일반적이고 권장됨
    response = client.patch("/todos/1", json={"is_done": False})

    # 5. undone() 메서드가 호출되었는지를 확인
    undone.assert_called_once_with()
    # undone이 한 번 실행되었다를 검증해줌
    # client.patch의 is_done 값을 True로 하면 에러가 남.
    # 요청이 True이면 done 메소드가 호출되도록 로직을 작성했기 때문

    assert response.status_code == 200
    assert response.json() == {"id": 1, "contents": "Mark", "is_done": False}

    # When 404
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=None
    )
    response = client.patch("/todos/1", json={"is_done": True})
    assert response.status_code == 404
    assert response.json() == {"detail": "Todo Not Found"}


def test_delete_todo(client, mocker):
    # When 204
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=ToDo(id=1, contents="Mark", is_done=True),
    )

    mocker.patch.object(ToDoRepository,
                        "delete_todo", return_value=None)

    response = client.delete("/todos/1")
    assert response.status_code == 204
    assert response.text == ""

    # When 404
    mocker.patch.object(ToDoRepository,
        "get_todo_by_id",
        return_value=None
    )
    response = client.delete("/todos/1")
    assert response.status_code == 404
    assert response.json() == {"detail": "ToDo Not Found"}