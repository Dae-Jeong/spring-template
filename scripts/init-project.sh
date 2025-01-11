#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 함수: 에러 메시지 출력
error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# 함수: 성공 메시지 출력
success() {
    echo -e "${GREEN}$1${NC}"
}

# 함수: 정보 메시지 출력
info() {
    echo -e "${YELLOW}$1${NC}"
}

# 함수: 파스칼 케이스로 변환
to_pascal_case() {
    echo "$1" | awk -F'[^[:alnum:]]' '{for(i=1;i<=NF;i++)printf "%s", toupper(substr($i,1,1)) substr($i,2)}' 
}

# 필수 인자 체크
if [ "$#" -lt 2 ]; then
    error "Usage: $0 <new-package-name> <new-project-name> [github-repo-url]"
fi

NEW_PACKAGE_NAME=$1
NEW_PROJECT_NAME=$2
GITHUB_REPO_URL=$3
OLD_PACKAGE_NAME="org.daejoeng"
OLD_PROJECT_NAME="spring-template"

# 프로젝트명을 파스칼 케이스로 변환 (예: my-project -> MyProject)
NEW_PROJECT_NAME_PASCAL=$(to_pascal_case "$NEW_PROJECT_NAME")
OLD_PROJECT_NAME_PASCAL="SpringTemplate"

# 현재 디렉토리가 프로젝트 루트인지 확인
if [ ! -f "build.gradle" ]; then
    error "Please run this script from the project root directory"
fi

info "Initializing new project with:"
info "Package name: $NEW_PACKAGE_NAME"
info "Project name: $NEW_PROJECT_NAME"
info "Application name: ${NEW_PROJECT_NAME_PASCAL}Application"
if [ ! -z "$GITHUB_REPO_URL" ]; then
    info "GitHub repository: $GITHUB_REPO_URL"
fi

# 1. build.gradle 수정
info "Updating build.gradle..."
sed -i '' "s/rootProject.name = '$OLD_PROJECT_NAME'/rootProject.name = '$NEW_PROJECT_NAME'/g" settings.gradle
sed -i '' "s/group = '$OLD_PACKAGE_NAME'/group = '$NEW_PACKAGE_NAME'/g" build.gradle

# 2. 패키지 디렉토리 구조 변경
info "Updating package structure..."
OLD_PACKAGE_PATH="src/main/java/org/daejoeng"
NEW_PACKAGE_PATH="src/main/java/$(echo $NEW_PACKAGE_NAME | tr '.' '/')"

# 새 패키지 디렉토리 생성
mkdir -p $NEW_PACKAGE_PATH

# 기존 파일들을 새 패키지로 이동
cp -r $OLD_PACKAGE_PATH/* $NEW_PACKAGE_PATH/

# 3. 패키지명 변경
info "Updating package names in source files..."
find $NEW_PACKAGE_PATH -type f -name "*.java" -exec sed -i '' "s/package $OLD_PACKAGE_NAME/package $NEW_PACKAGE_NAME/g" {} +
find $NEW_PACKAGE_PATH -type f -name "*.java" -exec sed -i '' "s/import $OLD_PACKAGE_NAME/import $NEW_PACKAGE_NAME/g" {} +

# 4. Application 클래스 이름 변경
info "Updating application class name..."
mv "$NEW_PACKAGE_PATH/SpringTemplateApplication.java" "$NEW_PACKAGE_PATH/${NEW_PROJECT_NAME_PASCAL}Application.java"
sed -i '' "s/SpringTemplateApplication/${NEW_PROJECT_NAME_PASCAL}Application/g" "$NEW_PACKAGE_PATH/${NEW_PROJECT_NAME_PASCAL}Application.java"

# 5. 기존 패키지 디렉토리 삭제
rm -rf src/main/java/org

# 6. Git 초기화
info "Initializing new Git repository..."
rm -rf .git
git init

# 7. Git hooks 설정
info "Setting up Git hooks..."
chmod +x scripts/setup-git-hooks.sh
./scripts/setup-git-hooks.sh

success "Project initialization completed successfully!"
success "New project '$NEW_PROJECT_NAME' is ready to use."
success "Git hooks are set up and ready to use."
if [ ! -z "$GITHUB_REPO_URL" ]; then
    success "GitHub repository URL: $GITHUB_REPO_URL"
fi
info "Next steps:"
info "1. Review the changes"
info "2. Run 'git add .' to stage all files"
info "3. Run 'git commit -m \"Initial commit\"' to create your first commit"
if [ ! -z "$GITHUB_REPO_URL" ]; then
    info "4. Run the following commands to push to GitHub:"
    info "   git remote add origin $GITHUB_REPO_URL"
    info "   git branch -M main"
    info "   git push -u origin main"
fi 