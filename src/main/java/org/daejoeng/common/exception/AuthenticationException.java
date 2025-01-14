/* (C)2025 */
package org.daejoeng.common.exception;

public class AuthenticationException extends BusinessException {
  public AuthenticationException(ErrorCode errorCode) {
    super(errorCode);
  }

  public AuthenticationException(ErrorCode errorCode, String message) {
    super(errorCode, message);
  }
}
