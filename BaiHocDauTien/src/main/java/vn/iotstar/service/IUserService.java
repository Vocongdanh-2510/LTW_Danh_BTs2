package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.User;

public interface IUserService {
    User login(String username, String password);
    void register(User user);
    User get(String username);
    User getByEmail(String email);
    User findById(int id);
    void update(User user);
    boolean checkExistEmail(String email);
    boolean checkExistUsername(String username);
    boolean checkExistPhone(String phone);
    List<User> findAll();
}
