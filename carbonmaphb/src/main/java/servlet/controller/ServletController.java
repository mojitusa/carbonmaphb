package servlet.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import servlet.impl.FileUp;
import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@Autowired
	private FileUp fileUpService;

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
		
		// ObjectMapper를 사용하여 리스트를 JSON 문자열로 변환
		ObjectMapper objectMapper = new ObjectMapper();
	    String jsonSdList = null;
	    
		try {
			jsonSdList = objectMapper.writeValueAsString(sd);

		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		model.addAttribute("jsonSdList", jsonSdList);
		

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
	
	@RequestMapping(value = "sdPu.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String, Object>> sdPu() {
		List<Map<String, Object>> sdPu = servletService.getSdPu();
		return sdPu;
	}
	
	@RequestMapping(value = "sggPu.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String, Object>> sggPu(@RequestBody Map<String, String> requestBody) {
		String sdnm = requestBody.get("sdSelected");
		System.out.println("param : " + sdnm);
		List<Map<String, Object>> sggPu = servletService.getSggPu(sdnm);
		System.out.println("sggPu : " + sggPu);
		
		return sggPu;
	}
	
	@RequestMapping(value = "bjdPu.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public List<Map<String, Object>> bjdPu(@RequestBody Map<String, String> requestBody) {
		String sggCd = requestBody.get("sggSelected");
		System.out.println("param : " + sggCd);
		List<Map<String, Object>> bjdPu = servletService.getBjdPu(sggCd);
		System.out.println("bjdPu : " + bjdPu);
		
		return bjdPu;
	}
	
    @RequestMapping(value = "Upload.do", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
    public String uploadFile(@RequestParam("file") MultipartFile file, RedirectAttributes redirectAttributes) {
        if (file.isEmpty()) {
            // 파일이 비어있을 경우 에러 메시지 반환 또는 처리
        	redirectAttributes.addFlashAttribute("message", "파일을 선택해주세요.");
            return "redirect:/carbonmap.do";
        }

        try {
            // 임시 디렉토리에 업로드된 파일을 저장
            String uploadDir = "C:\\uploads"; // 업로드 디렉토리 경로로 변경
            File dest = new File(uploadDir + File.separator + file.getOriginalFilename());
            file.transferTo(dest);
            System.out.println("파일 업로드 컨트롤러 작업을 시작합니다.");

            // 파일 업로드 서비스 호출
            fileUpService.uploadFile(dest.getAbsolutePath());
            

            // 업로드 후에는 적절한 페이지로 리다이렉트
            redirectAttributes.addFlashAttribute("message", "파일 업로드 성공: " + file.getOriginalFilename());
        } catch (IOException e) {
            e.printStackTrace();
            // 파일 업로드 중 에러가 발생했을 경우 에러 메시지 반환 또는 처리
            redirectAttributes.addFlashAttribute("message", "파일 업로드 중 오류가 발생했습니다.");
        }
        return "redirect:/carbonmap.do";
    }
}
