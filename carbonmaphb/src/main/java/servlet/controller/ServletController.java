package servlet.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
		 
		List<String> sd= new ArrayList<>();
		sd = servletService.getSd();
		
		System.out.println(sd);
		model.addAttribute("sdList", sd);
		
		return "carbonmap";
	}
	
	@RequestMapping(value = "sdSelect.do", method = RequestMethod.POST)
	@ResponseBody
	public String sdSelect(@RequestParam("selectedValue") String sd) {
	    System.out.println(sd);
	    return "success";
	}
	
}
