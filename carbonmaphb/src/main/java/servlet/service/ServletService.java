package servlet.service;

import java.util.List;
import java.util.Map;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<Map<String, Object>> getSd();

	List<Map<String, Object>> getSgg(String sd);

	List<Map<String, Object>> getbjd(String sggnm);

	String getSggCode(String sgg);

	Map<String, Object> selectGeom(String sd);

	Map<String, Object> selectSggGeo(String sggnm);

	List<Map<String, Object>> getSdPu();

	List<Map<String, Object>> getSggPu(String sdnm);

	List<Map<String, Object>> getBjdPu(String sggCd);

}
