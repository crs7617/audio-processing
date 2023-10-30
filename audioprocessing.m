% Load an audio signal
[y, Fs] = audioread('original_audio.wav');  % Replace with your audio file
[h, Fs_h] = audioread('room_impulse_response.wav');  % Replace with your RIR file

% Ensure both audio and impulse response are of the same sampling rate
if Fs ~= Fs_h
    error('Sampling rates of audio and impulse response must match.');
end

% Ensure the impulse response is shorter than the audio signal
if length(h) >= length(y)
    error('Impulse response must be shorter than the audio signal.');
end

% Convolve the audio signal with the room impulse response
convolved_audio = conv(y, h);

% Deconvolve to attempt to restore the original audio
restored_audio = deconv(convolved_audio, h);

% To prevent artifacts, truncate the restored audio to the original length
restored_audio = restored_audio(1:length(y));

% Play the original and restored audio
sound(y, Fs);
pause(length(y) / Fs);  % Pause to allow the original audio to play
sound(restored_audio, Fs);  % Play the restored audio

% Save the convolved and restored audio to files
audiowrite('convolved_audio.wav', convolved_audio, Fs);
audiowrite('restored_audio.wav', restored_audio, Fs);

% Plot the original, convolved, and restored audio signals
time = (0:length(y) - 1) / Fs;
figure;
subplot(3, 1, 1);
plot(time, y);
title('Original Audio');
xlabel('Time (s)');
subplot(3, 1, 2);
time_conv = (0:length(convolved_audio) - 1) / Fs;
plot(time_conv, convolved_audio);
title('Convolved Audio');
xlabel('Time (s)');
subplot(3, 1, 3);
plot(time, restored_audio);
title('Restored Audio');
xlabel('Time (s)');
