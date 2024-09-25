% Live audio recording parameters
Fs = 44100;  % Sampling frequency (44.1 kHz for high-quality audio)
nBits = 16;  % Bit depth
nChannels = 1;  % Number of channels (1 = Mono, 2 = Stereo)
recordDuration = 5;  % Duration of recording in seconds

% Create an audiorecorder object for live recording
recObj = audiorecorder(Fs, nBits, nChannels);

disp('Start speaking...');
recordblocking(recObj, recordDuration);
disp('Recording finished.');

% Get the recorded audio data
audioData = getaudiodata(recObj);

% Plot the recorded audio signal
figure;
subplot(3,1,1);
plot(audioData);
title('Original Audio Signal');
xlabel('Time');
ylabel('Amplitude');

% Delta Modulation Parameters
delta = 0.05;  % Step size for modulation
nSamples = length(audioData);  % Total number of audio samples
dmSignal = zeros(nSamples, 1);  % Delta Modulation signal output
quantizedSignal = zeros(nSamples, 1);  % Quantized signal
previousSample = 0;  % Initial value of the previous sample

% Delta Modulation Process
for i = 1:nSamples
    % Calculate the error between the current audio sample and the previous one
    error = audioData(i) - previousSample;
    
    % Quantize the error (using a step size)
    if error >= 0
        dmSignal(i) = 1;  % Output 1 if error is positive
        quantizedSample = previousSample + delta;
    else
        dmSignal(i) = -1;  % Output -1 if error is negative
        quantizedSample = previousSample - delta;
    end
    
    % Update the previous sample to the quantized value
    previousSample = quantizedSample;
    quantizedSignal(i) = quantizedSample;
end

% Plot the Delta Modulated signal (binary output)
subplot(3,1,2);
plot(dmSignal);
title('Delta Modulated Signal (Binary Output)');
xlabel('Time');
ylabel('Amplitude');

% Plot the Quantized Signal
subplot(3,1,3);
plot(quantizedSignal);
title('Reconstructed Quantized Signal');
xlabel('Time');
ylabel('Amplitude');
