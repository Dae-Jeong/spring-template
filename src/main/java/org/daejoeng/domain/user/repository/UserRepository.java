/* (C)2025 */
package org.daejoeng.domain.user.repository;

import java.util.Optional;
import org.daejoeng.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
  Optional<User> findByEmail(String email);

  boolean existsByEmail(String email);
}
