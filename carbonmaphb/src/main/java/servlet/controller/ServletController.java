package servlet.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;

	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model) throws Exception {
		System.out.println("sevController.java - mainTest()");

		String str = servletService.addStringTest("START! ");
		model.addAttribute("resultStr", str);

		return "main/main";
	}

	@RequestMapping(value = "/carbonmap.do")
	public String mapMap(Model model) {

		List<Map<String, Object>> sd = new ArrayList<>();

		sd = servletService.getSd();

		System.out.println(sd);
		model.addAttribute("sdList", sd);

		return "carbonmap";
	}
	
	@RequestMapping(value = "sdSelect.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String, Object> sdSelect(@RequestParam("selectedValue") String sd) {
		System.out.println(sd);
		System.out.println("시도 값이 들어왔어요.");

		List<Map<String, Object>> sgg = new ArrayList<>();
		sgg = servletService.getSgg(sd);
		Map<String, Object> geom = servletService.selectGeom(sd);
		
		// ObjectMapper를 사용하여 리스트를 JSON 문자열로 변환
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonSggList = null;

		try {
			jsonSggList = objectMapper.writeValueAsString(sgg);
			System.out.println("JSON 형태로 변환된 sggList: " + jsonSggList);

//			// JSON 문자열을 Java 객체로 변환하여 sgg_nm 필드 값만 포함하는 새로운 리스트 생성
//			List<String> sggNames = new ArrayList<>();
//
//			for (Map<String, Object> item : sgg) {
//				sggNames.add((String) item.get("sgg_nm"));
//			}
//
//			// 새로운 리스트를 JSON으로 변환
//			jsonSggList = objectMapper.writeValueAsString(sggNames);

		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Map<String,Object> res = new HashMap<>();
		res.put("sggList", jsonSggList);
		res.put("sggGeo", geom);

		return res;
	}

	@RequestMapping(value = "sggSelect.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public Map<String,Object> sggSelect(@RequestParam("sggName") String sggnm, Model model) {
		
		System.out.println(sggnm);
		System.out.println("시군구 값이 들어왔어요.");
		
		List<Map<String, Object>> bjd = new ArrayList<>();
		bjd = servletService.getbjd(sggnm);
		Map<String, Object> geom = servletService.selectSggGeo(sggnm);
	    
		// ObjectMapper를 사용하여 리스트를 JSON 문자열로 변환
		ObjectMapper objectMapper = new ObjectMapper();
	    String jsonBjdList = null;
	    
		try {
			jsonBjdList = objectMapper.writeValueAsString(bjd);
			System.out.println("JSON 형태로 변환된 bjdList: " + jsonBjdList);

		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Map<String,Object> res = new HashMap<>();
		res.put("bjdList", jsonBjdList);
		res.put("bjdGeo", geom);		
		
		return res;
	}
	
	@RequestMapping(value = "getSggcd.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String getSggcd(@RequestParam("sgg") String sgg) {
		String sggCode = servletService.getSggCode(sgg);
		
		return sggCode;
	}
	
	@RequestMapping(value = "legendSelect.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String legendSelect(@RequestParam("legendSelected") String lgd) {
		System.out.println("범례 : " + lgd);
		return lgd;
	}

}
