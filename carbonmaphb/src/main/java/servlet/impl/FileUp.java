package servlet.impl;
// YourService.java

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("FileUp")
public class FileUp {

    private final ServletDAO dao;

    @Autowired
    public FileUp(ServletDAO yourDAO) {
        this.dao = yourDAO;
    }

    public void uploadFile(String filePath) {
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                // 여러 열을 맵에 담기 위해 쉼표로 구분하여 데이터를 나눔
                String[] columns = line.split("|"); // 예시: 컬럼이 쉼표로 구분되어 있다고 가정
                Map<String, Object> dataMap = new HashMap<>();

                // 맵에 컬럼과 데이터를 쌍으로 저장
                // 여기서는 예시로 컬럼명이 컬럼1, 컬럼2, 컬럼3 등이라 가정
                // 실제 컬럼명에 맞게 수정해야 함
                dataMap.put("year_month_of_use", columns[0]);
                dataMap.put("site_location", columns[1]);
                dataMap.put("road_name_site_location", columns[3]);
                dataMap.put("city_county_district_code", columns[4]);
                dataMap.put("ligal_dong_code", columns[5]);
                dataMap.put("land_classification_code", columns[6]);
                dataMap.put("beon", columns[7]);
                dataMap.put("ji", columns[8]);
                dataMap.put("new_address_serial_number", columns[9]);
                dataMap.put("new_address_street_code", columns[10]);
                dataMap.put("new_address_above_ground_and_underground_code", columns[11]);
                dataMap.put("new_address_main_address_number", columns[12]);
                dataMap.put("new_address_sub_address_number", columns[13]);
                dataMap.put("power_usage", columns[14]);
                // 필요한 만큼 컬럼과 데이터를 추가
                
                // 수정된 데이터 맵을 DAO의 insertData 메서드에 전달
                dao.insertData(dataMap);
                
                // 스낵바 업데이트 코드 추가
                updateSnackbar();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 스낵바 업데이트 메서드
    private void updateSnackbar() {
        // 스낵바 업데이트 코드 작성
    }
}
