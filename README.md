# Gitlink
自動でadd/commit/push/pullを行う

```
git clone git@github.com:shucream/git-link.git ~/.gitlink

```

## how to use

```
# gitlink start                       # addされるとcommit/push/pullを行う
gitlink start -a                    # add/commit/push/pullを5分ごとに行う
gitlink start -a 6000               # add/commit/push/pullを10分ごとに行う
gitlink start -d                    # デーモン起動
gitlink start -d -a 6000 -branch branch_name   #ブランチを定する
gitlink stop
```
