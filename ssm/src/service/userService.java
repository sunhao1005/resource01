package service;

import bean.User;

public interface userService {

	int saveUser(User user);

	boolean ckeckUser(String username, String pwd);

}
