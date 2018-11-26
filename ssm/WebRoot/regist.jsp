<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'regist.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<link href="css/style.css" rel='stylesheet' type='text/css' media="all" />
  	<script type="text/javascript" src="js/regist.js"></script>
  	<script type="text/javascript" src="js/jquery.min.js"></script>
  </head>
  
  <body>
    <h1>Unique Regist Form</h1>
		<div class="log">
    
		<div class="content2">
		<h2>Sign Up Form</h2>
		<form action="regist.do" method="post">
			<span id="msg">${msg }</span><br/>
			<input type="text" id="username" name="username" value="USERNAME" onfocus="this.value = '';" >
			<input type="text" id="pwd" name="pwd" value="PASSWORD" onfocus="this.value = '';" >
			<input type="text" id="email" name="email" value="EMAIL ADDRESS" onfocus="this.value = '';" >
			<input type="text" id="phone" name="phone" value="PHONE" onfocus="this.value = '';" >
			<input type="submit" class="register" value="Register">
		</form>
		</div>
	<div class="clear"></div>
	</div>
	<div class="footer">
		<p>Copyright &copy; 2016.Company name All rights reserved.</p>
	</div>
  </body>
  
  <script type="text/javascript">
	$(document).ready(function(){
		var f1 = f2 = f3 = f4 = false;
		$("input:eq(0)").blur(function(){
			var reg = /^\w{3,20}$/;
	        var username = $("input:eq(0)").val();
	        if(username == null || username == "") {
	        	$("input:eq(0)").val("用户名不能为空");
	        	f1 = false;
	        } else if (reg.test(username)){
	        	$("input:eq(0)").val(username);
	        	f1 = true;
	        } else {
				$("input:eq(0)").val("用户名由数字、字母、下划线组成，长度为3-20");
	        	f1 = false;
	        };
	    });
	    $("input:eq(1)").blur(function(){
	    	var reg = /^\w{6,20}$/;
	        var password = $("input:eq(1)").val();
	        if(password == null || password == "") {
	        	$("input:eq(1)").val("密码不能为空");
	        	f2 = false;
	        } else if (reg.test(password)){
	        	$("input:eq(1)").val(password);
	        	f2 = true;
	        } else {
				$("input:eq(1)").val("密码由数字、字母组成，长度为6-20");
	        	f2 = false;
	        };
	    });
	    $("input:eq(2)").blur(function(){
	    	var reg = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
	        var email = $("input:eq(2)").val();
	        if(email == null || email == "") {
	        	$("input:eq(2)").val("邮箱不能为空");
	        	f3 = false;
	        } else if (reg.test(email)){
	        	$("input:eq(2)").val(email);
	        	f3 = true;
	        } else {
				$("input:eq(2)").val("邮箱格式不正确");
	        	f4 = false;
	        };
	    });
	    $("input:eq(3)").blur(function(){
	    	var reg = /^1[3,4,5,6,7,8,9]\d{9}$/;
	        var phone = $("input:eq(3)").val();
	        if(phone == null || phone == "") {
	        	$("input:eq(3)").val("电话号码不能为空");
	        	f4 = false;
	        } else if (reg.test(phone)){
	        	$("input:eq(3)").val(phone);
	        	f4 = true;
	        } else {
				$("input:eq(3)").val("电话号码不正确");
	        	f4 = false;
	        };
	    });
	    $("input:eq(4)").click(function(){
	        if(f1&&f2&&f3&&f4){
                return true;
            }else{
            	return false;
            }
	    });
	});
  </script>
</html>
