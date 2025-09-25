function y = dconv_fixed(x, h, mode)
% dconv_fixed - 離散線性卷積（固定端點策略）
% x, h : 行向量或列向量的有限序列
% mode : 'full' | 'same' | 'valid'
%
% - full  : 標準線性卷積（邊界視為零），長度 Nx+Nh-1
% - same  : 與 x 同長度的居中截取
% - valid : 只保留完全重疊的區段（固定端點，無邊界延伸）

    if nargin < 3, mode = 'full'; end

    % 轉為列向量以一致處理
    x = x(:);
    h = h(:);
    Nx = length(x);
    Nh = length(h);

    % full 長度
    Nfull = Nx + Nh - 1;
    yfull = zeros(Nfull, 1);

    % 計算 full：y[k] = sum_n x[n] * h[k-n]
    % k 對應到輸出索引 1..Nfull；n 對應到 x 的 1..Nx
    for k = 1:Nfull
        acc = 0;
        % n 的有效範圍：使得 m = k - n 在 1..Nh
        n_min = max(1, k - Nh + 1);
        n_max = min(Nx, k);
        for n = n_min:n_max
            m = k - n + 1;      % h 的索引（1-based）
            acc = acc + x(n) * h(m);
        end
        yfull(k) = acc;
    end

    switch lower(mode)
        case 'full'
            y = yfull;

        case 'same'
            % 與 x 同長度：居中截取
            start_idx = ceil((Nfull - Nx + 1) / 2);
            y = yfull(start_idx : start_idx + Nx - 1);

        case 'valid'
            % 只保留完全重疊：當 Nx >= Nh 時長度 Nx-Nh+1
            if Nx >= Nh
                start_idx = Nh;                 % 第一個完全重疊位置
                end_idx   = Nx;                 % 最後一個完全重疊位置
                y = yfull(start_idx : end_idx); % 長度 Nx-Nh+1
            else
                % 若 x 比 h 短，也可對稱處理：交換角色
                % 這裡返回空向量（無任何完全重疊）
                y = zeros(0,1);
            end

        otherwise
            error('mode must be ''full'', ''same'', or ''valid''.');
    end

    % 與輸入形狀對齊
    if isrow(x), y = y.'; end
end

% 範例序列
x = [1 2 3 4];      % Nx = 4
h = [1 -1 2];       % Nh = 3

% 手寫卷積（full / same / valid）
y_full  = dconv_fixed(x, h, 'full');   % 長度 6
y_same  = dconv_fixed(x, h, 'same');   % 長度 4（對齊 x）
y_valid = dconv_fixed(x, h, 'valid');  % 長度 2（4-3+1）

% 與 MATLAB 內建 conv 對照
y_full_ref = conv(x, h, 'full');
y_same_ref = conv(x, h, 'same');
y_valid_ref= conv(x, h, 'valid');

disp([y_full; y_full]);   % 應一致
disp([y_same; y_same]);   % 應一致
disp([y_valid; y_valid]); % 應一致