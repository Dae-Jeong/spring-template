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

# pre-commit이 설치되어 있는지 확인
if ! command -v pre-commit &> /dev/null; then
    error "pre-commit is not installed. Please install it first: pip install pre-commit"
fi

# 현재 디렉토리가 프로젝트 루트인지 확인
if [ ! -f "build.gradle" ]; then
    error "Please run this script from the project root directory"
fi

# pre-commit 설치 및 설정
info "Installing pre-commit hooks..."
pre-commit install || error "Failed to install pre-commit hooks"

# Spotless 적용
info "Running Spotless apply..."
./gradlew spotlessApply || error "Failed to apply Spotless"

success "Git hooks setup completed successfully!"
success "Pre-commit hooks are now installed and configured." 