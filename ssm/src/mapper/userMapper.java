package mapper;

import bean.User;

public interface userMapper {

	int saveUser(User user);
	User fingUserByname(String username);

}
