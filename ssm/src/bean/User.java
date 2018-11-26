package bean;

public class User {
	private int id;
	private String username;
	private String pwd;
	private String email;
	private String phone;
	public User(int id, String username, String pwd, String email, String phone) {
		super();
		this.id = id;
		this.username = username;
		this.pwd = pwd;
		this.email = email;
		this.phone = phone;
	}
	public User() {
		super();
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + id;
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		User other = (User) obj;
		if (id != other.id)
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "User [email=" + email + ", id=" + id + ", phone=" + phone
				+ ", pwd=" + pwd + ", username=" + username + "]";
	}
	
	
	
}