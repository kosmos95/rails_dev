
// Tab Content
function initTabMenu(tabContainerID) {
	var tabContainer = document.getElementById(tabContainerID);
	var tabAnchor = tabContainer.getElementsByTagName('a');
	//var tabAnchor = tabContainer.getElementsByClassName('tab');
	var current;
	//tab = tabContainer;

	for(i = 0, cnt = tabAnchor.length; i < cnt; i++) {
		//console.log( tabAnchor.item(i) );
    //tabAnchor.item(i).onclick = 
		tabAnchor.item(i).onmouseover = function () {
      
			this.targetEl = document.getElementById(this.href.split('#')[1]);
			this.imgEl = this.getElementsByTagName('img').item(0);
			
			if( this.targetEl == null) {
				return true;
			}
				
			if (this == current) {
				return false;
			}

			if (current) {
				current.targetEl.style.display = 'none';
				if (current.imgEl) {
					current.imgEl.src = current.imgEl.src.replace('_on.png', '.png');
				} else {
					current.className = current.className.replace(' on', '');
				}
			}
			
			this.targetEl.style.display = 'block';
			if (this.imgEl) {
				this.imgEl.src = this.imgEl.src.replace('.png', '_on.png');
			} else {
				this.className += ' on';
			}
			current = this;

			return false;
      
		};
	}
  
	tabAnchor.item(0).onmouseover();
}

/* Tab Example 

<div id="tab-container">
	<ul>
		<li><a href="#content1" class="tab"><img src="tab1.gif" alt="Show1"></a></li>
		<li><a href="#content2" class="tab"><img src="tab2.gif" alt="Show2"></a></li>
		<li><a href="#content3" class="tab"><img src="tab3.gif" alt="Show3"></a></li>
	</ul>
	<div id="content1">
		Content1
	</div>
	<div id="content2">
		Content2
	</div>
	<div id="content3">
		Content3
	</div>
</div>
<script type="text/javascript">
initTabMenu("tab-container");
</script>
*/

