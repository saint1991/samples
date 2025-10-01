import { Component, ElementRef, ViewChild, afterNextRender, inject, REQUEST, REQUEST_CONTEXT } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-about',
  imports: [],
  templateUrl: './about.component.html',
  styleUrl: './about.component.css'
})
export class AboutComponent {

  @ViewChild('container', { static: true }) container: ElementRef<HTMLDivElement> | undefined;

  protected userId: string | undefined = undefined;

  constructor(readonly route: ActivatedRoute) {
    const idParam = route.snapshot.paramMap.get('id');
    if (idParam) {
      this.userId = idParam;
    }

    const request = inject(REQUEST);
    if (request) {
      console.log('Request Headers:', request.headers);
      console.log('Request Method:', request.method);
      console.log('Request URL:', request.url);
    }
    
    afterNextRender(() => {
      if (this.container) {
        this.container.nativeElement.style.border = '2px solid blue';
      }
    })
  }

}
