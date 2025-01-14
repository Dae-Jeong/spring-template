/* (C)2025 */
package org.daejoeng.domain.auth.service;

import lombok.RequiredArgsConstructor;
import org.daejoeng.common.exception.BusinessException;
import org.daejoeng.common.exception.ErrorCode;
import org.daejoeng.common.security.JwtTokenProvider;
import org.daejoeng.domain.auth.dto.SignInRequest;
import org.daejoeng.domain.auth.dto.SignUpRequest;
import org.daejoeng.domain.auth.dto.TokenResponse;
import org.daejoeng.domain.user.entity.Role;
import org.daejoeng.domain.user.entity.User;
import org.daejoeng.domain.user.repository.UserRepository;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

  private final UserRepository userRepository;
  private final PasswordEncoder passwordEncoder;
  private final JwtTokenProvider tokenProvider;
  private final AuthenticationManagerBuilder authenticationManagerBuilder;

  @Transactional
  public void signUp(SignUpRequest request) {
    if (userRepository.existsByEmail(request.getEmail())) {
      throw new BusinessException(ErrorCode.DUPLICATE_EMAIL);
    }

    User user =
        User.builder()
            .email(request.getEmail())
            .password(passwordEncoder.encode(request.getPassword()))
            .name(request.getName())
            .role(Role.USER)
            .build();

    userRepository.save(user);
  }

  @Transactional
  public TokenResponse signIn(SignInRequest request) {
    // 1. 인증 토큰 생성
    UsernamePasswordAuthenticationToken authenticationToken =
        new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword());

    // 2. 실제 검증 (사용자 비밀번호 체크)
    Authentication authentication =
        authenticationManagerBuilder.getObject().authenticate(authenticationToken);

    // 3. 인증 정보를 기반으로 JWT 토큰 생성
    String accessToken = tokenProvider.createToken(authentication);
    String refreshToken = tokenProvider.createRefreshToken(authentication);

    return new TokenResponse(accessToken, refreshToken, "Bearer");
  }
}
