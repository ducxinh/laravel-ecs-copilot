# 認証基盤(Authentication infrastructure)

## 前提条件(prerequisite)

デプロイを実行するパソコンには下記のアプリがインストール状態になる必要がある
copilot
docker
node.js

## デプロイ(Deploy)

`dev` 環境

```bash
$ export AWS_PROFILE=deploy-realne-auth-dev
$ git checkout dev
# edit copilot/webapp/manifest.yml
#   sidecars > nginx > images を dev 環境の URL に変更する
$ bin/copilot-svc-deploy dev
```

`stg` 環境

```bash
$ export AWS_PROFILE=deploy-realne-auth-stg
$ git checkout stg
# edit copilot/webapp/manifest.yml
#   sidecars > nginx > images を stg 環境の URL に変更する
$ bin/copilot-svc-deploy stg
```

`prod` 環境

```bash
$ export AWS_PROFILE=deploy-realne-auth-prod
$ git checkout prod
$ bin/copilot-svc-deploy prod
```

## タグ付け

```bash
# dev
$ aws elbv2 add-tags \
  --resource-arns arn:aws:elasticloadbalancing:us-west-2:151874643243:loadbalancer/app/realn-Publi-KTQFPZS14UVL/ffa2f4cd19808843 \
  --tags Key=Product,Value=auth Key=Application,Value=auth Key=Environment,Value=dev

$ aws route53 change-tags-for-resource \
--resource-type hostedzone \
--resource-id Z03175781PVE5FTR9CMBT \
--add-tags Key=Product,Value=auth Key=Application,Value=auth Key=Environment,Value=dev

# prod
$ aws elbv2 add-tags \
  --resource-arns arn:aws:elasticloadbalancing:us-west-2:424838115375:loadbalancer/app/realn-Publi-W55JIF82ELMN/3a9c70f7d50dfcfb \
  --tags Key=Product,Value=auth Key=Application,Value=auth Key=Environment,Value=prod

$ aws route53 change-tags-for-resource \
--resource-type hostedzone \
--resource-id Z0694526FWALZPD9IYVB \
--add-tags Key=Product,Value=auth Key=Application,Value=auth Key=Environment,Value=prod
```
