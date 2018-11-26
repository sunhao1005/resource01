package controller;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import service.userService;

import bean.User;
@Controller
public class userController {
	@Autowired
	private userService userservice;
	
	@RequestMapping("/regist")
	public String regist(String username,String pwd,String email,String phone){
		User user=new User();
		user.setUsername(username);
		user.setEmail(email);
		user.setPhone(phone);
		user.setPwd(pwd);
		
		int re=userservice.saveUser(user);
		
		if(re==0){
			return "regist";
		}else{
		return "login";
		}
	}
	
	@RequestMapping("/login")
	public String login(String username,String pwd){
		System.out.println(username+pwd);
		boolean isok = userservice.ckeckUser(username, pwd);
		if(isok){
			return "regist";
		}else{ 
		
		return "login";}
	}
}
