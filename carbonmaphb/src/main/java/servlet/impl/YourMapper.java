package servlet.impl;
// YourMapper.java

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface YourMapper {
    void insertData(String data);
}
