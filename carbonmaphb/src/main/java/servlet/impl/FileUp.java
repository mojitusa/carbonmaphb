package servlet.impl;
// YourService.java

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import servlet.service.FileUpService;

@Service("FileUp")
public class FileUp implements FileUpService {

    private final ServletDAO dao;

    @Autowired
    public FileUp(ServletDAO yourDAO) {
        this.dao = yourDAO;
    }

    @Override
    public void uploadFile(String filePath) {
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            // 파일 크기 가져오기
            File file = new File(filePath);
            long fileSize = file.length();
            long bytesRead = 0;

            System.out.println("서비스에서 파일 업로드 작업을 시작합니다.");
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
                
	            try {
	                // 수정된 데이터 맵을 DAO의 insertData 메서드에 전달
	                dao.insertData(dataMap);   
	                
	                // 파일 업로드 진행 상황 업데이트
	                bytesRead += line.getBytes().length;
	                int progressPercent = (int) ((bytesRead * 100) / fileSize);
	                System.out.println("progressPercent: " + progressPercent);
	            } catch (Exception e) {
	                // 업로드 실패 시 오류 메시지 전송
	                e.printStackTrace();
	                return; // 업로드 실패 시 바로 리턴하여 메서드 종료
	            }	                
                
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


	@Override
	public void trunc() {
		dao.trunc();
	}
}
