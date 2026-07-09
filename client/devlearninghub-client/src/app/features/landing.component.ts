import { Component, OnDestroy, OnInit } from '@angular/core';
import { RouterLink } from '@angular/router';
@Component({selector:'app-landing',standalone:true,imports:[RouterLink],templateUrl:'./landing.component.html'})
export class LandingComponent implements OnInit, OnDestroy{
  ngOnInit(){document.body.classList.add('landing');}
  ngOnDestroy(){document.body.classList.remove('landing');}
}
