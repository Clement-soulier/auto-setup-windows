<h1>Overview</h1>
<p>A PowerShell script to automatically install my tools on a new Windows machine.</p>

<h1>Tools</h1>
<ul>
  <li><a href="https://chocolatey.org/">Chocolatey</a></li>
  <li><a href="https://www.git-scm.com/">Git</a></li>
  <li><a href="https://www.jetbrains.com/fr-fr/lp/mono/">JetBrains Mono</a></li>
  <li><a href="https://code.visualstudio.com/">VS Code</a></li>
  <li><a href="https://marketplace.visualstudio.com/items?itemName=vscodevim.vim">Vim extension</a></li>
  <li><a href="https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme">Material icon theme extensions</a></li>
  <li><a href="https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night">Tokyo night extension</a></li>
  <li>WSL</li>
  <li><a href="https://www.docker.com/">Docker</a></li>
</ul>

<h1>How it works</h1>
<p>The script install Chocolatey and then use it to install all the other tools. Wsl is the only tool to not use Chocolatey.
For VS Code it install 3 extensions and copy settings.json and keybingings.json to the right place.
Once all installations are performed, the script reboot the system to complete installations. Then you have to launch the verify.ps1 
script which verify that all tools are installed. In addition to the verification, it also ask you to configure you git user name and email.
Feel free to modify it and use it.</p>

<h1>To improve</h1>
<ul>
  <li>verify.ps1 run automatically</li>
</ul>