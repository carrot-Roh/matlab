% Title :  moving_segmentation.m
% Author : Donggeun Roh
% Version : 0.1
% Created : 22.09.03
% Modified : -
%
% 데이터를 특정 시간 크기(segment_sec)를 가지는 window로 추출하는데,
% 임의의 이동 간격(stride)으로 window를 움직이면서 추출함

% multi-array data
data = [];

% 데이터 나누기
sampling_rate = 125; % 125 Hz - 표본화 주파수
segment_sec = 2;    % 2 sec - 추출할 크기

% 이동 간격(stride)
% 몇 초 또는 샘플링 레이트의 몇 퍼센트로 샘플링 주파수를 기준으로 계산 예시
% 125 Hz 이기 때문에 소수점이 나오지 않도록 조절 할 것

stride_sec = 0.2;     % 0.2 초 이동 = 20% 이동과 같음
%stride_percent = 0.5; % 표본화 주파수(Hz)=1초 크기 샘플의 50% 이동

% 추출할 간격 크기, 샘플링 주파수 * 추출할 시간 간격
window_size = sampling_rate * segment_sec;

% 이동 간격 계산
window_stride = sampling_rate * stride_sec;
data_len = length(data); % 데이터 전체 길이

% window 크기와 stride 크기를 통해 최종적으로 몇 개의 출력물이 나올지 계산,
% 사용되는 데이터는 인공지능에 적용해야 되기 때문에 같은 크기의 데이터만 학습해야 함
% 그러므로, window 사이즈 미만의 데이터가 남는 경우 제거(내림,floor 이용)
z_idx = floor((data_len - window_size)/window_stride + 1);      % 계산식 검증 필요, 분할된 데이터의 수
output_data = zeros(size(data(:, window_size)), z_size);   % 최종 출력물, 사전 할당

current_idx = [];   % idx 계산을 위한 변수, 시작 점
segment_idx = [];   % 추출 구간 계산을 위한 변수
next_idx = 1;       % 다음 idx 위치 계산을 위함

for i = 1:z_idx
    current_idx = next_idx;
    segment_idx = current_idx:(current_idx+window_size); % 추출 구간
    
    % 사용하는 데이터에 맞게 수정 필요
    % 아래의 예시는 열>행 일 때를 기준으로 작성함
    temp = data(:, segment_idx);
    
    % 출력 데이터의 경우 3차원 데이터로 지정
    output_data(:, :, i) = temp;
    
    % 다음 idx 계산
    next_idx = segment_idx(end) + window_stride + 1;

end

% plot
plot(output_data);

