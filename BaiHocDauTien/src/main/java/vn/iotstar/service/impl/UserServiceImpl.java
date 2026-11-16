package vn.iotstar.service.impl;

import java.util.List;
import vn.iotstar.dao.IUserDao;
import vn.iotstar.dao.impl.UserDao;
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;

public class UserServiceImpl implements IUserService {

    private IUserDao userDao = new UserDao();

    @Override
    public User login(String username, String password) {
        User user = this.get(username);
        if (user != null && password != null && Utils.PasswordUtil.checkPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public void register(User user) {
        if (user.getPassword() != null) {
            user.setPassword(Utils.PasswordUtil.hashPassword(user.getPassword()));
        }
        userDao.insert(user);
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User getByEmail(String email) {
        return userDao.getByEmail(email);
    }

    @Override
    public User findById(int id) {
        return userDao.findById(id);
    }

    @Override
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public List<User> findAll() {
        return userDao.findAll();
    }
}
