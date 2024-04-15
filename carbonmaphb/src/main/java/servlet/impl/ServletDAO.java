package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<Map<String, Object>> getSd() {
		
		return selectList("servlet.getSd");
	}

	public List<Map<String, Object>> getSgg(String sd) {
		return selectList("servlet.getSgg", sd);
	}

	public List<Map<String, Object>> getbjd(String sggnm) {
		
		return selectList("servlet.getBjd", sggnm);
	}

	public String getSggCode(String sgg) {
		return selectOne("servlet.getSggCode", sgg);
	}

	public Map<String, Object> selectGeom(String sd) {
		return selectOne("servlet.selectSdGeo", sd);
	}
	
	public Map<String, Object> selectSggGeo(String sgg) {
		return selectOne("servlet.selectSggGeo", sgg);
	}

	public List<Map<String, Object>> getSdPu() {
		return selectList("servlet.getSdPu");
	}

	public List<Map<String, Object>> getSggPu(String sdnm) {
		return selectList(("servlet.getSggPu"), sdnm);
	}

	public List<Map<String, Object>> getBjdPu(String sggCd) {
		return selectList(("servlet.getBjdPu"), sggCd);
	}
	
	public void insertData(Map data) {
		insert(("servlet.insertData"), data);
	}

	public void trunc() {
		delete("servlet.truncateTb");
	}

}
