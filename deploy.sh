#!/usr/bin/env sh
# 确保脚本抛出遇到的错误
set -e
npm run build # 生成静态文件
cd docs/.vuepress/dist # 进入生成的文件夹

# deploy to github
#echo 'blog.xustar.com' > CNAME
if [ -z "$GITHUB_TOKEN" ]; then
  msg='deploy'
  githubUrl=git@github.com:SnailRunStar/xustar-blog.git
else
  msg='来自github action的自动部署'
  githubUrl=https://SnailRunStar:${GITHUB_TOKEN}@github.com/SnailRunStar/xustar-blog.git
  git config --global user.name "SnailRunStar"
  git config --global user.email "405198725@qq.com"
fi
git init
git add -A
git commit -m "${msg}"
git push -f $githubUrl master:gh-pages # 推送到github

# deploy to coding
#echo 'www.xustar.com\xustar.com' > CNAME  # 自定义域名
if [ -z "$CODING_TOKEN" ]; then  # -z 字符串 长度为0则为true；$CODING_TOKEN来自于github仓库`Settings/Secrets`设置的私密环境变量
  codingUrl=git@e.coding.net:xustar/star/xustar-blog.git
else
  codingUrl=https://xustar:${CODING_TOKEN}@e.coding.net/xustar/star/xustar-blog.git
fi
git add -A
git commit -m "${msg}"
git push -f $codingUrl master # 推送到coding

cd -
rm -rf docs/.vuepress/dist