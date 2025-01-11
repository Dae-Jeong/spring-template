#!/bin/bash

# 스크립트가 있는 디렉토리의 상위(프로젝트 루트) 디렉토리로 이동
cd "$(dirname "$0")/.." || exit

# pre-commit 파일 생성
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running spotless check..."

# Stash any changes not in staging area
git stash -q --keep-index

# Run spotless check
./gradlew spotlessCheck

# Store the last exit code
RESULT=$?

# Unstash changes
git stash pop -q

# Return the spotless result
exit $RESULT
EOF

# pre-commit 파일에 실행 권한 부여
chmod +x .git/hooks/pre-commit

echo "✅ Git hooks have been set up successfully!" 