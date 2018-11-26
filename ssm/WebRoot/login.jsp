<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'login.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<link href="css/style.css" rel='stylesheet' type='text/css' media="all" />
  </head>
  
  <body>
    <h1>Unique Login Form</h1>
		<div class="log">
    
    	<div class="content1">
		<h2>Sign In Form</h2>
		<span id="msg">${msg }</span><br/>
		<form action="login.do" method="post">
			<input type="text" name="username" value="USERNAME" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'USERNAME';}">
			<input type="password" name="pwd" value="PASSWORD" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'PASSWORD';}">
			<div class="button-row">
				<input type="submit" class="sign-in" value="Sign In">
				<input type="reset" class="reset" value="Reset">
			</div>
		</form>
		</div>
		<div class="clear"></div>
	</div>
	<div class="footer">
		<p>Copyright &copy; 2016.Company name All rights reserved.</p>
	</div>
  </body>
</html>
