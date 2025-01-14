/* (C)2025 */
package org.daejoeng.domain.auth.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.daejoeng.common.response.ApiResponse;
import org.daejoeng.domain.auth.dto.SignInRequest;
import org.daejoeng.domain.auth.dto.SignUpRequest;
import org.daejoeng.domain.auth.dto.TokenResponse;
import org.daejoeng.domain.auth.service.AuthService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "인증", description = "인증 관련 API")
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

  private final AuthService authService;

  @Operation(summary = "회원가입", description = "새로운 사용자를 등록합니다.")
  @PostMapping("/signup")
  public ApiResponse<Void> signUp(@Valid @RequestBody SignUpRequest request) {
    authService.signUp(request);
    return ApiResponse.success(null);
  }

  @Operation(summary = "로그인", description = "사용자 인증 후 JWT 토큰을 발급합니다.")
  @PostMapping("/signin")
  public ApiResponse<TokenResponse> signIn(@Valid @RequestBody SignInRequest request) {
    return ApiResponse.success(authService.signIn(request));
  }
}
