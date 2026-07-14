# 타자기 효과
# LocalScript


## 영어 버전
local function typeWriteEnglish(target, message)
    target.Text = ""
    for i = 1, #message do 
        target.Text = string.sub(message, 1, i) 
        task.wait(0.03)
    end
end

## 한국어 버전  (utf8 로 깨짐 방지)
local function typeWrite(target, message)
    target.Text = ""
    for i = 1, utf8.len(message) do 
        target.Text = string.sub(message, 1, utf8.offset(message, i+1)-1) 
        task.wait(0.03) 
    end
end

#### 3바이트 차지하는 한국어를 위한 직관적 버전 코드 (new) -- 사실 utf8 계산법 어려웠음 ㅎ but 1 바이트 -> 숫자, 영어 들어가면 인덱스 어긋나 에러 발생률 높음..ㅎ 걍 실험 코드임 
local function typeWrite(target, message)
     target.Text = ""
    for i = 3, #message, 3 do 
        target.Text = string.sub(message, 1, i)
        task.wait(0.03)
    end
end
