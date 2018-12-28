# ButtonChecker

## Register

- LoginViewController
- NewViewController

## Home

- HomeViewController

## User

- ProfileViewController
- Profile_EditViewController
- SingleyViewController

## Online

- PlayerViewController

- MemberViewController
- HostViewController

## Offline

- ViewController
- GameViewController

## Setting

- FeedbackViewController



# データベース

## User

|     Key      |     Value     |          内容          |
| :----------: | :-----------: | :--------------------: |
|     App      |     0or1      |       オンライン       |
| Defeat_count |      Int      |        負けた数        |
|  Win_count   |      Int      |        勝った数        |
|    RoomID    | Int or <null> | Online対戦のときのRoom |
|     uid      |    Random     |     ユーザーの識別     |
|   username   |    String     |     ユーザーの名前     |

