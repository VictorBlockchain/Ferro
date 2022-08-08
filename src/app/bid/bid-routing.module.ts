import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { BidComponent } from './bid.component';

const routes: Routes = [
  { path: '', component: BidComponent },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BidRoutingModule { }
