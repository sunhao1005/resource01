package service;

import mapper.userMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import bean.User;
@Service
public class userServiceImpl implements userService {
	@Autowired
   private userMapper usermapper;
	
	public int saveUser(User user) {
		int re=usermapper.saveUser(user);
		return re;
		
	}

	@Override
	public boolean ckeckUser(String username, String pwd) {
		User user=usermapper.fingUserByname(username);
		System.out.println(user);
		System.out.println("************"+user.getPwd().equals(pwd));
		if(user.getPwd().equals(pwd)){
			return true;
		}
		return false;
	}
	

}
