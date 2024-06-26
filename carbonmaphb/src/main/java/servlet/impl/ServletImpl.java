package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

	@Override
	public List<Map<String, Object>> getSd() {
		
		return dao.getSd();
	}

	@Override
	public List<Map<String, Object>> getSgg(String sd) {
		return dao.getSgg(sd);
	}

	@Override
	public List<Map<String, Object>> getbjd(String sggnm) {
		return dao.getbjd(sggnm);
	}

	@Override
	public String getSggCode(String sgg) {
		return dao.getSggCode(sgg);
	}

	@Override
	public Map<String, Object> selectGeom(String sd) {
		return dao.selectGeom(sd);
	}

	@Override
	public Map<String, Object> selectSggGeo(String sggnm) {
		return dao.selectSggGeo(sggnm);
	}

	@Override
	public List<Map<String, Object>> getSdPu() {
		return dao.getSdPu();
	}

	@Override
	public List<Map<String, Object>> getSggPu(String sdnm) {
		return dao.getSggPu(sdnm);
	}

	@Override
	public List<Map<String, Object>> getBjdPu(String sggCd) {
		return dao.getBjdPu(sggCd);
	}

}
