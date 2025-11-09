dispLevels = 16;

% Διάβασε τις εικόνες με τους χάρτες παραλλάξεων
gt = imread('GT.png');
dispMap = imread('Disparity.png');

% Αφαίρεσε τα τμήματα των εικόνων που δεν πρέπει να περιλαμβάνονται
gt = gt(:,dispLevels:end);
dispMap = dispMap(:,dispLevels:end);

% Θεώρησε σωστά τα άγνωστα εικονοστοιχεία (με ένταση μηδέν)
dispMap = dispMap.*uint8(gt>0);

% Επανέφερε τους δύο χάρτες παραλλάξεων στην κανονική τους μορφή
scaleFactor = 256/dispLevels;
gt = double(gt)/scaleFactor;
dispMap = double(dispMap)/scaleFactor;

% Υπολόγισε το rms σφάλμα και το ποσοστό των εσφαλμένων εικονοστοιχείων
n = numel(gt);
diff = dispMap-gt;
rmsError = sqrt(sum(sum(diff.^2))/n);
badPixels = abs(diff)>=1;
badPixelPercent = 100*sum(sum(badPixels))/n;

% Εμφάνισε το rms σφάλμα και το ποσοστό των εσφαλμένων εικονοστοιχείων
fprintf('rms error = %f\n',rmsError)
fprintf('bad pixel percentage = %f\n',badPixelPercent)

% Δημιούργησε τον χάρτη των εσφαλμένων εικονοστοιχείων
badPixelMap1 = ~badPixels*255;
badPixelMap2 = 255-uint8(abs(diff)*scaleFactor);

% Εμφάνισε και αποθήκευσε τον χάρτη των εσφαλμένων εικονοστοιχείων
figure; imshow(badPixelMap1)
imwrite(badPixelMap1,'BadPixels1.png')
figure; imshow(badPixelMap2)
imwrite(badPixelMap2,'BadPixels2.png')