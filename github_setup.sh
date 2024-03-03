ssh-keygen -t ed25519 -C "ian@ianq.ai"
eval `ssh-agent -s`
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
git config --global user.email "ian@ianq.ai"; git config --global user.name "IQ"
