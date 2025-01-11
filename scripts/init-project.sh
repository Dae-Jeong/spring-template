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

# 필수 인자 체크
if [ "$#" -ne 2 ]; then
    error "Usage: $0 <new-package-name> <new-project-name>"
fi

NEW_PACKAGE_NAME=$1
NEW_PROJECT_NAME=$2
OLD_PACKAGE_NAME="org.daejoeng"
OLD_PROJECT_NAME="spring-template"

# 현재 디렉토리가 프로젝트 루트인지 확인
if [ ! -f "build.gradle" ]; then
    error "Please run this script from the project root directory"
fi

info "Initializing new project with:"
info "Package name: $NEW_PACKAGE_NAME"
info "Project name: $NEW_PROJECT_NAME"

# 1. build.gradle 수정
info "Updating build.gradle..."
sed -i '' "s/rootProject.name = '$OLD_PROJECT_NAME'/rootProject.name = '$NEW_PROJECT_NAME'/g" settings.gradle

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

# 4. 기존 패키지 디렉토리 삭제
rm -rf src/main/java/org

# 5. Git 초기화
info "Initializing new Git repository..."
rm -rf .git
git init
git add .
git commit -m "Initial commit from template"

# 6. 이 스크립트 자신을 삭제
info "Cleaning up initialization script..."
rm -- "$0"

success "Project initialization completed successfully!"
success "New project '$NEW_PROJECT_NAME' is ready to use."
success "Please review the changes and update any remaining references manually if needed." 