---
title: Organizers
...

<!-- TODO less padding around the bubbles -->
<!-- TODO move to CSS and unify with all pages -->
<!-- TODO and make this a template -->

<h2>2018 Organizing Committee</h2>

<div style="max-width: 90%;">
<ul class="personList">
$for(current)$
$partial("templates/person.html")$
$endfor$
</ul>
</div>

<!-- TODO why is daniel showing up below this?? some kind of off-by-one error lol -->

<h2>Past Committee Members</h2>

<div style="max-width: 750px;">
<ul class="personList">
$for(previous)$
$partial("templates/person.html")$
$endfor$
</ul>
</div>
