/* (C)2025 */
package org.daejoeng.common.security;

import org.daejoeng.common.exception.BusinessException;
import org.daejoeng.common.exception.ErrorCode;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtil {
  private SecurityUtil() {
    throw new IllegalStateException("Utility class");
  }

  public static String getCurrentUsername() {
    final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    if (authentication == null || authentication.getName() == null) {
      throw new BusinessException(ErrorCode.INVALID_TOKEN);
    }

    return authentication.getName();
  }

  public static Long getCurrentUserId() {
    final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    if (authentication == null || authentication.getName() == null) {
      throw new BusinessException(ErrorCode.INVALID_TOKEN);
    }

    return Long.parseLong(authentication.getName());
  }
}
