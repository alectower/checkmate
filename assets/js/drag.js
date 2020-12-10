let Drag = (() => {
  let mouseDown = (event) => {
    let piece = event.target;
    let shiftX = event.clientX - piece.getBoundingClientRect().left + 197;
    let shiftY = event.clientY - piece.getBoundingClientRect().top + 8;

    document.getElementsByTagName("main")[0].append(piece);
    piece.classList.add("drag")

    let moveAt = (pageX, pageY) => {
      piece.style.left = pageX - shiftX + 'px';
      piece.style.top = pageY - shiftY + 'px';
    }

    moveAt(event.pageX, event.pageY);

    let onMouseMove = (event) => {
      moveAt(event.pageX, event.pageY);
    }

    document.addEventListener('mousemove', onMouseMove);

    document.addEventListener("mouseover", (e) => {
      console.log(e.target)
      if (window.Dragging) {
        window.Hovered = e.target.id
      }
    })

    piece.onmouseup = () => {
      document.removeEventListener('mousemove', onMouseMove);
      piece.onmouseup = null;
    };
  }

  return {
    mouseDown: mouseDown
  }
})()

export {Drag};
