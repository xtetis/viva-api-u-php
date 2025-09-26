@include('blocks.head')
@include('blocks.preloader')
@include('blocks.sidebar_menu')
@include('blocks.header_topbar')
<!-- [ Main Content ] start -->
<div class="pc-container">
    <div class="pc-content">
        @include('blocks.breadcrumb')
        <!-- [ Main Content ] start -->
        <div class="row">
            <!-- [ sample-page ] start -->
            <div class="col-sm-12">
                <div class="card">
                    <div class="card-body">
                        @yield('page_content')
                    </div>
                </div>
            </div>
            <!-- [ sample-page ] end -->
        </div>
        <!-- [ Main Content ] end -->
    </div>
</div>
<!-- [ Main Content ] end -->
@include('blocks.footer')
@include('blocks.endbody')
