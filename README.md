# prj1_testFile
## 2023 OSS project 1
12223693 권신범

## 프로젝트 소개
제공된 u.item u.data u.user 파일을 읽고 9개의 명령을 수행할 수 있는 Bash Shell 파일을 구현

### 개발 환경
- ubuntu (Linux)
- Bash

## 주요 기능
#### MENU 출력
- ITEM_File=”u.item”
- DATA_File=”u.data”
_ USER_File=”u.user”
while :
do ... done : exit 입력을 받을 때까지 파일 실행 
case $order in ... esac : if 문 대신 case~esac 문 사용

#### Get the data of the movie identified by a specific ‘movie id’ from ‘u.item’
- 유저 입력 받기
- awk 사용, u.item file 에서 유저 입력과 동일한 movie id($1) 를 지닌 행 출력
- -F ”|” : | 를 기준으로 데이터 나누기
- -v id=”$movieId” : awk 외부 변수 사용

#### Get the data of action genre movies from ‘u.item’
- 유저 입력 받기
- awk 사용, u.item file 에서 action genre 의 데이터가 1 인 movie id($1) 와 movie name($2) 출력
- sort -n : 순서상 오름차순 정렬
- head -n 10 : 선착순 10개

#### Get the average ‘rating’ of the movie identified by specific ‘movie id’ from ‘u.data’
- 유저 입력 받기
- awk 사용, u.data file 에서 유저 입력과 동일한 movie id($2)를 지닌 행의 rating 평균 출력
- {sum += $3; n++} : rating($3) 의 총합과 movie 가 평가받은 횟수(n) 계산
- END : 입력 파일의 모든 행을 처리 후 후위 명령 실행
- printf “%.5f”, sum / n : rating 의 총합을 평가받은 횟수로 나눈 결과를 소수점 다섯 번째 자리까지 출력
- awk 결과를 출력

#### Delete the ‘IMDb URL’ from ‘u.data’
- 유저 입력 받기
- if [ “$ans” = “y” ]; then ... fi : 만약 유저 입력($ans)가 y라면 다음 명령을 수행하는 if문
- sed 사용, http로 시작하는 문자열을 삭제하는 명령 수행
- -n ‘1, 10 ... : 1번째 행부터 10번째 행까지
- s/http[^|]*//p’ : s 명령어를 통해 http로 시작하고 | 문자 이전까지([^|]*)의 문자열을 “”로 대체

#### Get the data about users from ‘u.user’
- 유저 입력 받기
- sed 사용, user gender data 가 M 일 경우와 F 일 경우로 나누어 실행 
- s/ ... \(M\) ... .*/User \1 is \2 years old Male \4/; : user gender data 가 M 일 경우
- s/ ... \(F\) ... .*/User \1 is \2 years old Female \4/; : user gender data 가 F 일 경우 
- .* : 이후의 정보는 무시

#### Modify the format of ‘release data’ in ‘u.item’
- 유저 입력 받기
- sed 사용
- -n ‘1673,1682... : 1673번째 행부터 1682번째 행까지
- s/\([0-9]\{2\}\)-”MMM”-\([0-9]\{4\}\)/\2MM\1/ : rate date 에 대한 데이터를 지닌 “[0-9]\{2 or 4\}” 2개 혹은 4개의 숫자와 month 문자로 구성된 부분을 찾아 추출, “\(...\)” 를 사용해 특정 부분을 추출하여 \2MM\1로 순서를 바꾸어 출력, 각 월의 축약과 일치하는 명령문을 모두 작성

#### Get the data of movies rated by a specific ‘user id’ from ‘u.data’
- 유저 입력 받기
- rating : awk 사용, user id 를 통해 해당 user 가 평가한 영화 id 추출해 출력
- tr “\n” “|” : 추출 시 기본 문자열 끝맺음인 “\n” 대신에 “|” 사용
- movieIds : rating 과 동일하나 tr “\n” “ “  사용하여 for 문을 순회하도록 추출
- for movieId in $movieIds; do ... done | head -n 10 : movieIds의 정보를 movieId로 넘겨받고 앞에서 10개의 출력만 수행

#### Get the average ‘rating’ of movies rated by users with ‘age’ between 20 and 29 and ‘occupation’ as ‘programmer’
- 유저 입력 받기
- result : user file 에서 나이가 20~29인 programmer data 추출
- for userId in $result; do ... done : data file 에서 movie id 와 rating 을 info.txt 더미파일에 저장
- awk -F “|” ‘{ ... } : info.txt 에 저장된 movie id 와 rating 정보를 sum[ movie_id_index ] = rating sum rating 합 배열에 저장, count[ movie_id_idx ] 값 갱신
- END { ... }’ : 평균 출력 
- sort -n : 정렬
 
#### Exit
- “Bye!” 출력
- exit 0 파일 종료

