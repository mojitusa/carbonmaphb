package servlet.controller;

import java.util.ArrayList;
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
		 
		List<Map<String, Object>> sd= new ArrayList<>();
		
		sd  = servletService.getSd();
		
		System.out.println(sd);
		model.addAttribute("sdList", sd);
		
		return "carbonmap";
	}
	
	@RequestMapping(value = "sdSelect.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public String sdSelect(@RequestParam("selectedValue")  String sd) {
	    System.out.println(sd);
	    System.out.println("값이 들어왔어요.");
	    
	    List<Map<String, Object>> sgg= new ArrayList<>();
	    sgg = servletService.getSgg(sd);
	    System.out.println(sgg);
	    
	    // ObjectMapper를 사용하여 리스트를 JSON 문자열로 변환
	    ObjectMapper objectMapper = new ObjectMapper();
	    String jsonSggList = null;	  
	    
	    try {
			jsonSggList = objectMapper.writeValueAsString(sgg);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    
	    return jsonSggList;
	}
	
}
